import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";

import type { Accessor } from "ags";
import { Gdk, Gtk } from "ags/gtk4";
import { exec, execAsync } from "ags/process";
import { createPoll } from "ags/time";

type MicState = "muted" | "recording" | "error" | "ready" | "stopped";

interface MicStatus {
	text: string;
	state: MicState;
	tooltip: string;
}

const CONTROLS = `Left click: record
Right click: mute/unmute
Middle click: restart`;

function isServiceRunning(): boolean {
	try {
		exec(["systemctl", "--user", "is-active", "--quiet", "hyprwhspr.service"]);
		return true;
	} catch {
		return false;
	}
}

function isServiceFailed(): boolean {
	try {
		exec(["systemctl", "--user", "is-failed", "--quiet", "hyprwhspr.service"]);
		return true;
	} catch {
		return false;
	}
}

function isRecording(): boolean {
	if (!isServiceRunning()) return false;

	const statusFile = `${GLib.get_home_dir()}/.config/hyprwhspr/recording_status`;
	const file = Gio.File.new_for_path(statusFile);

	if (!file.query_exists(null)) return false;

	try {
		const [, contents] = file.load_contents(null);
		const status = new TextDecoder().decode(contents).trim();
		if (status !== "true") return false;

		// Check audio_level staleness
		const levelFile = Gio.File.new_for_path(
			`${GLib.get_home_dir()}/.config/hyprwhspr/audio_level`,
		);
		const now = Math.floor(Date.now() / 1000);

		if (levelFile.query_exists(null)) {
			const info = levelFile.query_info(
				"time::modified",
				Gio.FileQueryInfoFlags.NONE,
				null,
			);
			const mtime = Math.floor(info.get_modification_date_time()!.to_unix());
			return now - mtime <= 2;
		}

		const statusInfo = file.query_info(
			"time::modified",
			Gio.FileQueryInfoFlags.NONE,
			null,
		);
		const statusMtime = Math.floor(
			statusInfo.get_modification_date_time()!.to_unix(),
		);
		return now - statusMtime <= 1;
	} catch {
		return false;
	}
}

function isMicMuted(): boolean {
	try {
		const output = exec(["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]);
		return output.includes("[MUTED]");
	} catch {
		return false;
	}
}

async function getMicInfo(): Promise<string> {
	try {
		const output = await execAsync([
			"bash",
			"-c",
			`pactl list sources 2>/dev/null | awk -v D="$(pactl get-default-source 2>/dev/null)" '/^[[:space:]]*Name:/{name=$2} /^[[:space:]]*Sample Specification:/{spec=$3" "$4" "$5} name==D && spec{print spec; exit}'`,
		]);
		const spec = output.trim();
		return spec ? `Mic: ${spec}` : "";
	} catch {
		return "";
	}
}

function getMicStatus(): Accessor<MicStatus> {
	return createPoll<MicStatus>(
		{ text: "󰍬", state: "stopped", tooltip: "" },
		500,
		async () => {
			let text: string;
			let state: MicState;
			let micLine: string;

			if (isMicMuted()) {
				text = "󰍭 MUTE";
				state = "muted";
				micLine = "Microphone: muted";
			} else if (isRecording()) {
				text = "● REC";
				state = "recording";
				micLine = "Microphone: recording";
			} else if (isServiceRunning()) {
				if (isServiceFailed()) {
					text = "󰍬 ERR";
					state = "error";
					micLine = "Microphone: active";
				} else {
					text = "󰍬";
					state = "ready";
					micLine = "Microphone: active";
				}
			} else {
				text = "󰍬";
				state = "stopped";
				micLine = "Microphone: active (hyprwhspr stopped)";
			}

			const micHw = await getMicInfo();
			const tooltip = `${micLine}${micHw ? `\n${micHw}` : ""}\n\n${CONTROLS}`;

			return { text, state, tooltip };
		},
	);
}

async function doRecord(): Promise<void> {
	const controlFile = `${GLib.get_home_dir()}/.config/hyprwhspr/recording_control`;

	if (isRecording()) {
		await execAsync(["bash", "-c", `echo "stop" > "${controlFile}"`]);
	} else {
		if (!isServiceRunning()) {
			await execAsync(["systemctl", "--user", "start", "hyprwhspr.service"]);
			await new Promise((resolve) => setTimeout(resolve, 500));
		}
		await execAsync(["bash", "-c", `echo "start" > "${controlFile}"`]);
	}
}

async function doRestart(): Promise<void> {
	await execAsync(["systemctl", "--user", "restart", "hyprwhspr.service"]);
	execAsync([
		"notify-send",
		"-i",
		"/usr/lib/hyprwhspr/share/assets/hyprwhspr.png",
		"hyprwhspr",
		"Restarted",
	]).catch(() => {});
}

async function doMute(): Promise<void> {
	await execAsync(["wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle"]);
}

export const MicHyprwhspr = () => {
	const status = getMicStatus();

	return (
		<Gtk.Box
			class={status((s) => `mic-hyprwhspr ${s.state}`)}
			tooltipText={status((s) => s.tooltip)}
			$={(self) => {
				const gesture = Gtk.GestureClick.new();
				gesture.set_button(0); // Listen to all buttons

				gesture.connect("released", () => {
					const button = gesture.get_current_button();
					switch (button) {
						case Gdk.BUTTON_PRIMARY:
							doRecord().catch(console.error);
							break;
						case Gdk.BUTTON_SECONDARY:
							doMute().catch(console.error);
							break;
						case Gdk.BUTTON_MIDDLE:
							doRestart().catch(console.error);
							break;
					}
				});

				self.add_controller(gesture);
			}}
		>
			<Gtk.Label label={status((s) => s.text)} />
		</Gtk.Box>
	);
};

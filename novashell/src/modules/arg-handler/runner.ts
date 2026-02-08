import { generalConfig } from "~/config";
import { execApp } from "~/modules/apps";
import type { RemoteCaller } from "~/modules/arg-handler/types";
import { isHelpArg } from "~/modules/arg-handler/utils";

const runnerHelp = `Run applications and command aliases defined in the novashell
configuration.

Help:
  client_modifiers: Hyprland client modifiers(e.g.: "[animation slide]")

Options:
  h, help: show this help message.

Usage:
  run %aliasName [client_modifiers]: run a command alias defined in the config.
  run appName[.desktop] [client_modifiers]: run an ordinary app(uses uwsm if available).`;

export function handleRunnerArgs(
	cmd: RemoteCaller,
	args: Array<string>,
): number {
	if (isHelpArg(args[1])) {
		cmd.print_literal(runnerHelp);
		return 0;
	}

	if (args[1] === undefined || args[1].trim() === "") {
		cmd.printerr_literal(
			'Error: No application/alias to run provided after "run"',
		);
		return 1;
	}

	if (args[1].startsWith("%")) {
		const aliasName = args[1].replace(/^%/, "");
		const command = generalConfig.getProperty(`aliases.${aliasName}`, "string");

		if (command !== undefined && command.trim() !== "") {
			cmd.print_literal("Executing from alias...");
			execApp(command, args[2] || undefined);
			return 0;
		}

		cmd.printerr_literal(
			"Error: provided alias couldn't be found in the aliases list",
		);
		return 1;
	}

	cmd.print_literal(
		`Executing app from ${
			args[1].endsWith(".desktop") ? "desktop entry" : "command"
		}...`,
	);
	execApp(args[1], args[2] || undefined);
	return 0;
}

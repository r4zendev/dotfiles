export const stripHash = (hex: string) => hex.replace(/^#/, "");

export function adjustLightness(hex: string, amount: number): string {
	const h = hex.replace(/^#/, "");
	const r = Math.max(
		0,
		Math.min(255, parseInt(h.substring(0, 2), 16) + amount),
	);
	const g = Math.max(
		0,
		Math.min(255, parseInt(h.substring(2, 4), 16) + amount),
	);
	const b = Math.max(
		0,
		Math.min(255, parseInt(h.substring(4, 6), 16) + amount),
	);
	return `#${r.toString(16).padStart(2, "0")}${g.toString(16).padStart(2, "0")}${b.toString(16).padStart(2, "0")}`;
}

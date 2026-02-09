export type { ResolvedIcon } from "./resolver";
export {
	getAppIcon,
	getIconByAppName,
	getSymbolicIcon,
	invalidateIconLookupCache,
	lookupIcon,
	resolveIcon,
	resolveIconFromClasses,
} from "./resolver";
export {
	getGeneratedIconThemeName,
	shouldUseGeneratedIconTheme,
	updateIconTheme,
} from "./theme-manager";
export {
	resolveNetworkIcon,
	resolveStatusIconName,
	resolveVolumeStatusIcon,
} from "./ui-icons";

import { addDynamicIconSelectors } from "@iconify/tailwind";
import daisyui from "daisyui";
import type { Config } from "tailwindcss";

export default {
	content: { relative: true, files: ["**/*.rs"] },
	theme: { extend: {} },
	plugins: [daisyui, addDynamicIconSelectors()],
} satisfies Config;

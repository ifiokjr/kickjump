import type { Config } from "tailwindcss";

export default {
	content: { relative: true, files: ["**/*.rs"] },
	theme: { extend: {} },
	plugins: [require("daisyui")],
} satisfies Config;

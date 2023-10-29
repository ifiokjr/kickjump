const path = require("path");

/**
 * @type {import("eslint").Linter.Config}
 */
const config = {
	parser: "@typescript-eslint/parser",
	ignorePatterns: ["*.d.ts"],
	plugins: [
		"@typescript-eslint",
		"eslint-plugin-unicorn",
		"eslint-plugin-file-progress",
	],
	extends: [
		"eslint:recommended",
		"plugin:@typescript-eslint/recommended",
		"plugin:playwright/recommended",
	],

	parserOptions: {
		ecmaFeatures: { jsx: true },
		ecmaVersion: 2023,
		sourceType: "module",
		project: [path.join(__dirname, "./tsconfig.json")],
	},
	settings: { react: { version: "detect" } },
	env: { es6: true, browser: true, node: true },
	rules: {
		"file-progress/activate": 1,
		"prefer-const": ["error", { destructuring: "all" }],

		"unicorn/no-keyword-prefix": "off",
		"unicorn/no-unsafe-regex": "off",
		"unicorn/no-unused-properties": "off",
		"unicorn/string-content": "off",
		"unicorn/custom-error-definition": "off",
		"unicorn/empty-brace-spaces": "off",
		"unicorn/prevent-abbreviations": "off",
		"unicorn/no-nested-ternary": "off",
		"unicorn/no-null": "off",
		"no-nested-ternary": "off",
		"unicorn/prefer-module": "off",
		"sort-imports": "off",
		"@typescript-eslint/no-unused-expressions": [
			"warn",
			{ allowTernary: true, allowShortCircuit: true },
		],
		"@typescript-eslint/no-unused-vars": ["off"], // Use TS's built in one
		"@typescript-eslint/naming-convention": [
			"warn",
			{ selector: "typeParameter", format: ["StrictPascalCase"] },
		],
		"@typescript-eslint/no-non-null-assertion": "warn",
		"@typescript-eslint/no-inferrable-types": "warn",
		"@typescript-eslint/consistent-type-imports": ["error", {
			disallowTypeAnnotations: false,
		}],
		"@typescript-eslint/explicit-module-boundary-types": "off",

		// Turning off as it leads to code with bad patterns, where implementation
		// details are placed before the actual meaningful code.
		"@typescript-eslint/no-use-before-define": "off",
		"@typescript-eslint/member-ordering": [
			"warn",
			{
				default: [
					"signature",
					"static-field",
					"static-method",
					"field",
					"constructor",
					"method",
				],
			},
		],
		"@typescript-eslint/method-signature-style": "warn",
		"@typescript-eslint/prefer-function-type": "error",
		"@typescript-eslint/array-type": [
			"error",
			{ default: "array-simple", readonly: "array-simple" },
		],

		// Require typescript parser
		"@typescript-eslint/prefer-readonly": "warn",
		"@typescript-eslint/consistent-type-exports": ["error"],
		"@typescript-eslint/await-thenable": "warn",
		"@typescript-eslint/no-unnecessary-type-arguments": "warn",
		"@typescript-eslint/restrict-plus-operands": "warn",
		"@typescript-eslint/no-misused-promises": "warn",
		"@typescript-eslint/no-unnecessary-type-assertion": "error",

		// Built in eslint rules
		"no-constant-condition": "off", // To many false positives
		"no-empty": "warn",
		"no-else-return": "warn",
		"no-useless-escape": "warn",
		"default-case": "off",
		"default-case-last": "error",
		"prefer-template": "warn",
		"guard-for-in": "warn",
		"prefer-object-spread": "warn",
		curly: ["warn", "all"],
		"no-invalid-regexp": "error",
		"no-multi-str": "error",
		"no-extra-boolean-cast": "error",
		radix: "error",
		"no-return-assign": ["error", "except-parens"],
		eqeqeq: ["error", "always", { null: "ignore" }],
		"prefer-exponentiation-operator": "error",
		"prefer-arrow-callback": ["error", { allowNamedFunctions: true }],
		"padding-line-between-statements": [
			"warn",
			{
				blankLine: "always",
				prev: "*",
				next: ["if", "switch", "for", "do", "while", "class", "function"],
			},
			{
				blankLine: "always",
				prev: ["if", "switch", "for", "do", "while", "class", "function"],
				next: "*",
			},
		],

		"no-restricted-syntax": [
			"error",
			{
				selector:
					"ImportDeclaration[source.value='react'] :matches(ImportDefaultSpecifier, ImportNamespaceSpecifier)",
				message:
					"Default React import not allowed since we use the TypeScript jsx-transform.",
			},
		],

		"@typescript-eslint/no-var-requires": "off",
	},
};

module.exports = config;

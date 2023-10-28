import { expect, test } from "@playwright/test";

test("homepage", async ({ page }) => {
	await page.goto("http://localhost:53124/");
	await expect(page).toHaveTitle("Home | KickJump");
	await expect(page.locator("h1")).toHaveText("KickJump!");
});

test("example page", async ({ page }) => {
	await page.goto("http://localhost:53124/example");
	await expect(page).toHaveTitle("Example | KickJump");
});

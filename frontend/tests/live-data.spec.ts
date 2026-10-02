import { expect, test } from '@playwright/test'

test('loads governed Snowflake data through FastAPI', async ({ page }) => {
  const apiResponses = Promise.all([
    page.waitForResponse(
      (response) => response.url().endsWith('/api/dashboard/summary'),
    ),
    page.waitForResponse((response) =>
      response.url().includes('/api/suppliers?limit=5'),
    ),
    page.waitForResponse((response) =>
      response.url().includes('/api/parts/risk?limit=6'),
    ),
  ])

  await page.goto('http://127.0.0.1:5173/')

  const responses = await apiResponses
  expect(responses.map((response) => response.status())).toEqual([200, 200, 200])
  await expect(page.locator('.source-chip')).toContainText('Live governed data')
  await expect(page.locator('.snapshot-alert')).toHaveCount(0)

  await page.screenshot({
    path: '../submission-assets/dashboard-live-desktop.png',
    fullPage: true,
  })
  await page.getByRole('button', { name: 'Ask governed data' }).click()
  await expect(page.locator('.answer-content')).toBeVisible({ timeout: 90_000 })
  await page.locator('.assistant-layout').screenshot({
    path: '../submission-assets/governed-answer-evidence.png',
  })
  await page.setViewportSize({ width: 390, height: 844 })
  await page.screenshot({
    path: '../submission-assets/dashboard-live-mobile.png',
    fullPage: true,
  })
})
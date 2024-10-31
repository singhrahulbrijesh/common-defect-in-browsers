import time

from selenium import webdriver
from selenium.webdriver.common.by import By

browser = webdriver.Chrome()
browser.get("https://issues.chromium.org/issues?q=status:open%20type:bug")
time.sleep(3)
to_continue = True

while to_continue:
    for index in range(0, 25):
        results = browser.find_elements(By.CLASS_NAME, "row-issue-title")
        results[index].click()
        time.sleep(5)
        title = browser.find_element(By.CLASS_NAME, "heading-m.ng-star-inserted").text
        description = browser.find_element(By.CLASS_NAME, "type-m").text
        print("Title: " + title)
        print("Description: " + description)
        browser.back()
        time.sleep(5)

    button = browser.find_element(By.CLASS_NAME, "mat-focus-indicator.large.right.compact.mat-icon-button.mat-button-base.mat-primary")
    if button.is_enabled():
        to_continue = True
        button.click()
        time.sleep(5)
    else:
        to_continue = False

from imports import *


def main():


    report = '''<html>
    <head>
    <title>HTML File</title>
    </head> 
    <body>'''
    report = report+safe_test(test_crud, "Test 1")
    report = report+safe_test(test_two, "Test 2")
    report = report+safe_test(test_three, "Test 3")
    report = report+'''</body>
            </html>'''
    file_html = open("demo.html", "w")
    file_html.write(report)
    file_html.close()
    driver.close()


if __name__ == "__main__":
    main()

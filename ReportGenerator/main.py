from imports import *
from utils.report_generator import report_generator


def main():
    test_login()
    test_crud()
    report_generator.generate_report()
    driver.close()


if __name__ == "__main__":
    main()

from imports import *


def main():
    DriverSetup.start()
    test_login()
    test_crud()
    report_generator.generate_report()
    DriverSetup.close()


if __name__ == "__main__":
    main()

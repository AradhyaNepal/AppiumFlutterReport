def safe_test(func,string,driver):
    try:
        func(driver)
        return "<p>"+string+": Pass</p>"
    except:
        return "<p>"+string+": Failed</p>"
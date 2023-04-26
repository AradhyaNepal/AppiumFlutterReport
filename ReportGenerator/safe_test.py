def safe_test(func,string):
    try:
        func()
        return "<p>"+string+": Pass</p>"
    except:
        return "<p>"+string+": Failed</p>"
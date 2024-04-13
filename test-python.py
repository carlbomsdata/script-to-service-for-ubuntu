import time

def main():
    while True:
        print("Service is running at {}".format(time.ctime()))
        time.sleep(10)

if __name__ == "__main__":
    main()

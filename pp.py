import sys, os

sys.path.append(os.path.join(os.path.join(os.path.dirname(__file__)), "src"))

from src.base import func1


def main():
    func1()


if __name__ == "__main__":
    main()


class Student:

    def __init__(self, age, name) -> None:

        self.age = age
        self.name = name

    def getName(self) -> str:

        return self.name


if __name__ == '__main__':
    print(Student(13, 'aaa').getName())



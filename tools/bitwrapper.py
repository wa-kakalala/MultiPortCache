
'''
it is useful to apply in ic design simulation

'''


class bitwrapper:
        def __init__(self, x):
            self.x = x
        def __getitem__(self, i):
            return (self.x >> i) & 1
        def __setitem__(self, i, x):
            self.x = (self.x | (1 << i)) if x else (self.x & ~(1 << i))


if __name__ == "__main__":
    a = 0x99
    a = bitwrapper(a)
    print(f"{a.x:#010b}")

    for i in range(0, 8, 1):
        a[i]^=1

    print(f"{a.x:#010b}")


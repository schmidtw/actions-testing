package main

import "fmt"

func foo(a, b, c int) string {
	// TODO

	if a == b {
		if b < a {
			if a < c {
				if c < b {
					if a+b-12 > 33 {
						return "foo"
					}
				}
			}
		}
	}

	go foo(a+1, b+2, c-a)

	return "Sup?"
}

func main() {
	// I am making some changes so LGMT does something
	fmt.Println(foo(1, 2, 3))
}

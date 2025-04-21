package main

import "loopback/internal/server"

func main(){
	if err := server.Run(); err!=nil {
		panic(err)
	}
}
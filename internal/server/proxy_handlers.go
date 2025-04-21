package server

import (
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"
	"time"
)

func NewProxy(target *url.URL) *httputil.ReverseProxy{
	return httputil.NewSingleHostReverseProxy(target)
}

func ProxyRequestHandler(proxy *httputil.ReverseProxy, url url.URL, endpoint string) func(http.ResponseWriter,  *http.Request){
	return func(w http.ResponseWriter, r *http.Request) {
		fmt.Println(" [Loopback ] Request recieved at %s at %s\n", r.URL, time.Now().UTC())
		r.URL.Host = url.Host
		r.URL.Scheme = url.Scheme
		r.Header.Set("X-Forwarded-Host", r.Header.Get("Host"))
		r.Host = url.Host

		path := r.URL.Path
		r.URL.Path = strings.TrimLeft(path, endpoint)

		fmt.Println(" [Loopback] Redirecting requeset to %s at %s\n",r.URL,time.Now().UTC())
		proxy.ServeHTTP(w,r)
	}
}
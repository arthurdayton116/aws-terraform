package main

import (
	"context"
	"testing"
)

func TestHandleRequest(t *testing.T) {
	type args struct {
		ctx  context.Context
		name MyEvent
	}
	tests := []struct {
		name    string
		args    args
		want    string
		wantErr bool
	}{
		// TODO: Add test cases.
		{"test",
			args{
			 nil,
			MyEvent{Name: "Fred"},
			},
			"Fred",
			false,
			},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ctx, _ := context.WithDeadline(context.Background(), d)
			tt.args.ctx = ctx
			got, err := HandleRequest(tt.args.ctx, tt.args.name)
			if (err != nil) != tt.wantErr {
				t.Errorf("HandleRequest() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("HandleRequest() got = %v, want %v", got, tt.want)
			}
		})
	}
}

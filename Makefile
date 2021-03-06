NAME=$(lastword $(subst /, ,$(abspath .)))
VERSION=$(shell $(TYPE) version.txt)
GOOPT=-ldflags "-s -w"
ifeq ($(OS),Windows_NT)
    SHELL=CMD.EXE
    SET=set
    TYPE=type
    DEL=del
else
    SET=export
    TYPE=cat
    DEL=rm
endif

all:
	$(SET) "CGO_ENABLED=0" && go build $(GOOPT)

package:
	$(foreach GOARCH,386 amd64,\
	    $(SET) "GOARCH=$(GOARCH)" && \
	    $(SET) "CGO_ENABLED=0" && \
	    go build -o $(NAME).exe $(GOOPT) && \
	    zip -9 $(NAME)-$(VERSION)-windows-$(GOARCH).zip $(NAME).exe && ) :
	$(SET) "GOARCH=amd64" && $(SET) "GOOS=linux" && \
	    go build -o $(NAME) $(GOOPT) && \
	    tar zcvf $(NAME)-$(VERSION)-linux-amd64.tar.gz $(NAME)

clean:
	$(DEL) *.zip *.tar.gz $(NAME) $(NAME).exe

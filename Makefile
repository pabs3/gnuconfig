SHELL=/usr/pkg/bin/bash
UPLOAD=ftp://ftp-upload.gnu.org/incoming/ftp/

upload:
	gpg --detach-sign config.guess 
	gpg --detach-sign config.sub
	echo "directory: config" | gpg --clearsign > config.guess.directive
	cp config.guess.directive config.sub.directive
	ftp -a -u $(UPLOAD) config.{guess,sub}{,.sig,.directive}
	rm config.{guess,sub}{,.sig,.directive}

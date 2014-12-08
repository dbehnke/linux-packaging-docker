
pkg_name=hello
pkg_ver=0.1
deb_dist=wheezy
rpm_dist=centos6

all: docker image-build-deb-${deb_dist} build-${deb_dist} \
	image-build-rpm-${rpm_dist} build-${rpm_dist}

# ensure docker is working - user responsibility to install docker binaries
# and have it working
# this is just a check docker runs, if it fails the make script will fail.
.PHONY: docker
docker:
	docker version

# debian

# creates a container (if it doesn't exist)
image-build-deb-${deb_dist}: docker container-clean-build-deb-${deb_dist}
	cd docker/build-deb-${deb_dist} && docker build -t build-deb:${deb_dist} .

# cleans named container
container-clean-build-deb-${deb_dist}: docker
	docker rm build-deb-${deb_dist}

.IGNORE: container-clean-build-deb-${deb_dist}
build-${deb_dist}: container-clean-build-deb-${deb_dist} \
	image-build-deb-${deb_dist}
	docker run --name build-deb-${deb_dist} \
		-v ${PWD}:/project \
		-it build-deb:${deb_dist} make deb --directory=/project

# rpm

# creates a container (if it doesn't exist)
image-build-rpm-${rpm_dist}: docker container-clean-build-rpm-${rpm_dist}
	cd docker/build-rpm-${rpm_dist} && docker build -t build-rpm:${rpm_dist} .

# cleans named container
container-clean-build-rpm-${rpm_dist}: docker
	docker rm build-rpm-${rpm_dist}

.IGNORE: container-clean-build-rpm-${rpm_dist}
build-${rpm_dist}: container-clean-build-rpm-${rpm_dist} \
	image-build-rpm-${rpm_dist}
	docker run --name build-rpm-${rpm_dist} \
		-v ${PWD}:/project \
		-it build-rpm:${rpm_dist} make rpm --directory=/project

#only run this from a container
deb:
	if [ -d build-temp ]; then rm -r -f build-temp; fi
	mkdir build-temp
	cd build-temp && cp -R /project/src-root .
	cd build-temp && mv src-root ${pkg_name}-${pkg_ver}
	cd build-temp/${pkg_name}-${pkg_ver} && \
		dpkg-buildpackage -us -uc 
	if [ ! -d output ]; then mkdir output; fi
	cp build-temp/*.dsc output
	cp build-temp/*.gz output
	cp build-temp/*.changes output
	cp build-temp/*.deb output

#only run this from a container
rpm:
	#if [ -d rpmbuild ]; then rm -r -f rpmbuild; fi
	mkdir /root/rpmbuild
	mkdir /root/rpmbuild/SOURCES
	mkdir /root/rpmbuild/SPEC
	cp src-root/${pkg_name}.spec /root/rpmbuild/SPEC/
	mkdir /tmp/${pkg_name}
	cp -R src-root/* /tmp/${pkg_name}
	cd /tmp && tar cvf ${pkg_name}-${pkg_ver}.tar.gz ${pkg_name}
	mv /tmp/${pkg_name}-${pkg_ver}.tar.gz /root/rpmbuild/SOURCES/
	rm -r -f /tmp/${pkg_name}
	rpmbuild -ba /root/rpmbuild/SPEC/${pkg_name}.spec
	if [ ! -d output ]; then mkdir output; fi
	cp /root/rpmbuild/RPMS/noarch/*.rpm output
	cp /root/rpmbuild/SRPMS/*.src.rpm output

clean:
	if [ -d build-temp ]; then rm -r -f build-temp; fi
	#if [ -d rpmbuild ]; then rm -r -f rpmbuild; fi
	if [ -d output ]; then rm -r -f output; fi

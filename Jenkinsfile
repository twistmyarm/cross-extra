pipeline {
	agent any

	stages {
		stage('Build') {
			steps {
				sh '''
cleanup()
{
	rm -rf ${WORKSPACE}/proto /var/tmp/${BUILD_TAG}
}

tar_exit_success()
{
	cd ${WORKSPACE}
	mkdir -p output
	gtar -zcpf output/proto.tar.gz ./proto
	exit 0
}

tar_exit_fail()
{
	cd ${WORKSPACE}
	mkdir -p output
	gtar -zcpf output/proto-failed.tar.gz ./proto
	cd /var/tmp
	gtar -zcpf ${WORKSPACE}/output/failed-build-dir.tar.gz ./${BUILD_TAG}
	exit 1
}

trap cleanup INT TERM EXIT

# Ensure we start with a clean work area
cleanup
rm -f ${WORKSPACE}/output

gmake WORKDIR=/var/tmp/${BUILD_TAG} MAX_JOBS=32 || tar_exit_fail

#
# Errors are not propogated correctly so manually check for expected files.
#
[ -f proto/i86pc/usr/gcc/7/bin/i386-pc-solaris2.11-gcc ] || tar_exit_fail
[ -f proto/i86pc/usr/gnu/bin/gnm ] || tar_exit_fail
[ -f proto/i86pc/usr/lib/cpp ] || tar_exit_fail
#
[ -f proto/armv8/usr/gcc/7/bin/aarch64-unknown-elf-gcc ] || tar_exit_fail
[ -f proto/armv8/usr/gnu/bin/gnm ] || tar_exit_fail
[ -f proto/armv8/usr/lib/cpp ] || tar_exit_fail
#
[ -f proto/riscv/usr/gcc/7/bin/riscv64-unknown-elf-gcc ] || tar_exit_fail
[ -f proto/riscv/usr/gnu/bin/gnm ] || tar_exit_fail
[ -f proto/riscv/usr/lib/cpp ] || tar_exit_fail

tar_exit_success
				'''
				archiveArtifacts artifacts: 'output/*.gz', fingerprint: true
			}
		}
	}
}

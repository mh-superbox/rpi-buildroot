BR_SRC_DIR=../buildroot
UNIPI_SRC_DIR=$(pwd)
OUTPUT=$UNIPI_SRC_DIR/output

cd $BR_SRC_DIR

#make O=$OUTPUT BR2_EXTERNAL=
make O=$OUTPUT BR2_EXTERNAL=$UNIPI_SRC_DIR/buildroot BR2_TARGET_GENERIC_HOSTNAME=unipi-1 clean all

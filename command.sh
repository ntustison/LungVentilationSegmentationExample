#! /usr/bin/sh

DATA_DIR=./InputData/

VENTILATION_IMAGE=${DATA_DIR}/ventilationImage.nii.gz
LUNG_MASK=${DATA_DIR}/lungMask.nii.gz

# Dilate the lung mask so that the background gets
#   included in the segmetnation processing.

DILATED_MASK=./lungMaskDilated.nii.gz
${ANTSPATH}/ImageMath 3 $DILATED_MASK MD $LUNG_MASK 5

# Run antsAtroposN4.sh which iterates between n4 bias
#    correction and segmentation

PREFIX=./output
SEGMENTATION=${PREFIX}Segmentation.nii.gz
POSTERIOR1=${PREFIX}SegmentationPosteriors1.nii.gz
POSTERIOR2=${PREFIX}SegmentationPosteriors2.nii.gz
POSTERIOR3=${PREFIX}SegmentationPosteriors3.nii.gz
POSTERIOR4=${PREFIX}SegmentationPosteriors4.nii.gz

${ANTSPATH}/antsAtroposN4.sh -d 3 \
                             -a $VENTILATION_IMAGE \
                             -x $DILATED_MASK \
                             -r [0.3,2x2x2]   \
                             -n 5             \
                             -m 5             \
                             -c 4             \
                             -y 2 -y 3 -y 4   \
                             -o $PREFIX

# Correct the segmentation and posteriors with the mask

${ANTSPATH}/ImageMath 3 $SEGMENTATION m $SEGMENTATION $LUNG_MASK
${ANTSPATH}/ImageMath 3 $POSTERIOR1 m $POSTERIOR1 $LUNG_MASK
${ANTSPATH}/ImageMath 3 $POSTERIOR2 m $POSTERIOR2 $LUNG_MASK
${ANTSPATH}/ImageMath 3 $POSTERIOR3 m $POSTERIOR3 $LUNG_MASK
${ANTSPATH}/ImageMath 3 $POSTERIOR4 m $POSTERIOR4 $LUNG_MASK

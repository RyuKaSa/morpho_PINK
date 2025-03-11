# source ~/Pinktmp/.pink.start

rm -rf tempo
find  . -name 'result*' -exec rm {} \;
mkdir tempo


# Exercice 1_1
heightminima uo.pgm 4 20 tempo/out1.pgm
pgm2GA tempo/out1.pgm 2 tempo/out2.ga
GAwatershed tempo/out2.ga tempo/out3.ga
GA2khalimsky tempo/out3.ga 0 tempo/out4.pgm
zoom tempo/out4.pgm 0.5 result_1_1_BW.pgm
surimp uo.pgm result_1_1_BW.pgm result_1_1_RED_DIFF.pgm

# the file tempo/out6 represents in red the segmentations of exercice 1, part 1.

# Exercice 1_2
# starting point is file : result_1_1_BW.pgm
frame tempo/out4.pgm 1 test.pgm
inverse tempo/out4.pgm result_1_1_BW_inverse.pgm
geodilat test.pgm result_1_1_BW_inverse.pgm 4 -1 testtest.pgm


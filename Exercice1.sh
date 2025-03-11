# source ~/Pinktmp/.pink.start

rm -rf tempo
find  . -name 'result*' -exec rm {} \;
mkdir tempo

# -----------------------------------
# Exercice 1_1
# -----------------------------------

heightminima uo.pgm 4 20 tempo/out1.pgm
pgm2GA tempo/out1.pgm 2 tempo/out2.ga
GAwatershed tempo/out2.ga tempo/out3.ga
GA2khalimsky tempo/out3.ga 0 tempo/out4.pgm
zoom tempo/out4.pgm 0.5 result_1_1_BW.pgm
surimp uo.pgm result_1_1_BW.pgm result_1_1_RED_DIFF.pgm

# the file result_1_1_RED_DIFF.pgm represents in red the segmentations of exercice 1, part 1.


# -----------------------------------
# Exercice 1_2
# -----------------------------------

# starting point is file : result_1_1_BW.pgm
frame tempo/out4.pgm 1 tempo/out5.pgm
inverse tempo/out4.pgm tempo/out6.pgm
geodilat tempo/out5.pgm tempo/out6.pgm 4 -1 tempo/out7.pgm
sub tempo/out6.pgm tempo/out7.pgm result_1_2_BW.pgm
zoom result_1_2_BW.pgm 0.5 tempo/out9.pgm
inverse tempo/out9.pgm tempo/out10.pgm 
surimp uo.pgm tempo/out10.pgm result_1_2_RED_DIFF.pgm

# The file result_1_2_RED_DIFF.pgm represents in red the differences, which shows the cells we removed on the edges of the image.
# the cells that are kept are visible in white in the file result_1_2_BW.pgm 


# -----------------------------------
# Exercice 1_3
# -----------------------------------

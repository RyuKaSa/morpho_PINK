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

total_white_pixels=$(area result_1_2_BW.pgm)
echo "Total white pixels: $total_white_pixels"

num_components=$(nbcomp result_1_2_BW.pgm 4 fgd)
echo "Number of components: $num_components"

# Calculate the average number of pixels per component
if [ "$num_components" -gt 0 ]; then
    avg_pixels_per_component=$((total_white_pixels / num_components))
    echo "Average pixels per component: $avg_pixels_per_component"
else
    echo "No components found."
fi
# this outputs :
# ```
# Total white pixels: 364581
# Number of components: 101
# Average pixels per component: 3609
# ```

# -----------------------------------
# Exercice 2_1
# -----------------------------------

# white pixels are blood cells in out12, they are in black in out11
seuil bloodcells.pgm 128 tempo/out11.pgm
inverse tempo/out11.pgm tempo/out12.pgm
areaclosing tempo/out12.pgm 4 500 result_2_1_BW.pgm
inverse result_2_1_BW.pgm tempo/out11.pgm
surimp bloodcells.pgm result_2_1_BW.pgm result_2_1_RED_DIFF.pgm


# -----------------------------------
# Exercice 2_2
# -----------------------------------

# remove from edges
frame tempo/out11.pgm 1 tempo/out13.pgm
inverse tempo/out11.pgm tempo/out14.pgm
geodilat tempo/out13.pgm tempo/out14.pgm 4 -1 tempo/out15.pgm
sub tempo/out14.pgm tempo/out15.pgm result_2_2_BW.pgm
surimp bloodcells.pgm result_2_2_BW.pgm result_2_2_RED_DIFF.pgm


# -----------------------------------
# Exercice 2_3
# -----------------------------------

# -----------------------------------
# Exercice 2_3: Separate Touching Cells
# -----------------------------------

dist result_2_2_BW.pgm 1 tempo/distMap.pgm
long2byte tempo/distMap.pgm 1 tempo/distMap_Byte.pgm
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
seuil bloodcells.pgm 136 tempo/out11.pgm
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
# do distance on complement of components, so when BG is white, to get ragional maximums, for cell centers,
# then inverse the distance map to get BG as max height, and cap before the valleys touch, to get separated cells 

inverse result_2_2_BW.pgm tempo/out16.pgm
dist tempo/out16.pgm 1 tempo/out17.pgm
long2byte tempo/out17.pgm 1 tempo/out18.pgm
inverse tempo/out18.pgm tempo/out19.pgm
pgm2GA tempo/out19.pgm 2 tempo/out20.ga
GAwatershed tempo/out20.ga tempo/out21.ga
GA2khalimsky tempo/out21.ga 0 tempo/out22.pgm
pgm2GA result_2_2_BW.pgm 1 tempo/out23.ga
GA2khalimsky tempo/out23.ga 0 tempo/out24.pgm
sub tempo/out24.pgm tempo/out22.pgm result_2_3_BW.pgm
zoom result_2_3_BW.pgm 0.5 tempo/out25.pgm
surimp bloodcells.pgm tempo/out25.pgm result_2_3_RED_DIFF.pgm

# -----------------------------------
# Exercice 2_4
# -----------------------------------

# Calculate the total number of white pixels in the binary image result_2_3_BW.pgm
total_white_pixels=$(area result_2_3_BW.pgm)
echo "Total white pixels: $total_white_pixels"

# Count the number of components (connected components) in the image result_2_3_BW.pgm (after Exercice 2_3)
num_components_after=$(nbcomp result_2_3_BW.pgm 4 fgd)
echo "Number of components (after Exercice 2_3): $num_components_after"

# Count the number of components (connected components) in the image result_2_2_BW.pgm (before Exercice 2_3)
num_components_before=$(nbcomp result_2_2_BW.pgm 4 fgd)
echo "Number of components (before Exercice 2_3): $num_components_before"

# Calculate the number of components that were broken up during the process
if [ "$num_components_after" -gt "$num_components_before" ]; then
    num_broken_up=$((num_components_after - num_components_before))
    echo "Number of components that were broken up: $num_broken_up"
else
    echo "No components were broken up."
fi

# Calculate the average number of pixels per component after the process
if [ "$num_components_after" -gt 0 ]; then
    avg_pixels_per_component=$((total_white_pixels / num_components_after))
    echo "Average pixels per component (after Exercice 2_3): $avg_pixels_per_component"
else
    echo "No components found after Exercice 2_3."
fi

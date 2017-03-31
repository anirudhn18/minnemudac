quality = read.csv( "qlty.csv" )

model = lm(qlty ~ yr*factor(lake_name), data= quality)

summary(model)


names(model)
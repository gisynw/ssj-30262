path = "D:\\student_test"

setwd(path)

shinylive::export(appdir = path, destdir = "docs")

# Using code to open docs locally
httpuv::runStaticServer("docs")
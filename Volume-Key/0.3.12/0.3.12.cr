class Target < ISM::Software

    def prepare
        super

        runAutoreconfCommand(["-fiv"],buildDirectoryPath)
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--without-python",
                            "#{option("Swig") ? "--with-python3" : "--without-python3"}"],
                            buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end

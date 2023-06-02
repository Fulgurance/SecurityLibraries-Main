class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static"],
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

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/lib/libhogweed.so",0o755)
        setPermissions("#{Ism.settings.rootPath}usr/lib/libnettle.so",0o755)
    end

end

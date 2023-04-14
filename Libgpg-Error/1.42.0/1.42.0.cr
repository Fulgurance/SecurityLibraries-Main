class Target < ISM::Software

    def configure
        super

        configureSource(["--prefix=/usr"],buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgpg-error-1.42")

        copyFile("#{buildDirectoryPath(false)}README","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/libgpg-error-1.42/README")
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/share/doc/libgcrypt-1.9.4/README",0o644)
    end

end

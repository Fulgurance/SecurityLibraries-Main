class Target < ISM::Software

    def prepare
        super

        fileReplaceTextAtLineNumber("#{buildDirectoryPath(false)}src/posix-io.c","defined(__sun) || defined(__FreeBSD__)","1",573)
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-gpg-test"],
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

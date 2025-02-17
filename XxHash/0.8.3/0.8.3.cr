class Target < ISM::Software

    def build
        super

        makeSource( arguments:  "PREFIX=/usr"
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr    \
                                DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end

class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                  \
                                    --enable-hashes=strong,glibc    \
                                    --enable-obsolete-api=no        \
                                    --disable-static                \
                                    --disable-failure-tokens",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end

class Target < ISM::Software

    def prepare
        super

        runAutoreconfCommand(   arguments:  "-fiv",
                                path:       buildDirectoryPath)
    end

    def configure
        super

        configureSource(arguments:      "--prefix=/usr      \
                                        --disable-static    \
                                        --with-default-dict=/usr/lib/cracklib/pw_dict",
                        path:           buildDirectoryPath,
                        environment:    {"PYTHON" => "python3"})
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end

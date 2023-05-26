class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath(false)}util/packer.c",61)
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-default-dict=/usr/lib/cracklib/pw_dict"],
                            path: buildDirectoryPath,
                            environment: {   "PYTHON" => "python3",
                                "CPPFLAGS" => "-I/usr/include/python3.9"})
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

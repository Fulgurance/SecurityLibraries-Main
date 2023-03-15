class Target < ISM::Software

    def prepare
        super

        fileDeleteLine("#{buildDirectoryPath}util/packer.c",61)
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--disable-static",
                            "--with-default-dict=/usr/lib/cracklib/pw_dict"],
                            buildDirectoryPath,
                            "",
                            {   "PYTHON" => "python3",
                                "CPPFLAGS" => "-I/usr/include/python3.9"})
    end

    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end

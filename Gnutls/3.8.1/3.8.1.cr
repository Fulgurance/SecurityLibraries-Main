class Target < ISM::Software

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/gnutls-3.8.1",
                            "#{option("Libunistring") ? "" : "--with-included-unistring"}",
                            "--with-default-trust-store-pkcs11=\"pkcs11:\""],
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

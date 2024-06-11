class Target < ISM::Software

    def prepare
        if option("32Bits") || option("x32Bits")
            @buildDirectory = true
        end

        if option("32Bits")
            @buildDirectoryNames["32Bits"] = "mainBuild-32"
        end

        if option("x32Bits")
            @buildDirectoryNames["x32Bits"] = "mainBuild-x32"
        end
        super
    end

    def configure
        super

        configureSource([   "--prefix=/usr",
                            "--enable-hashes=strong,glibc",
                            "--enable-obsolete-api=no",
                            "--disable-static",
                            "--disable-failure-tokens"],
                            path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            configureSource([   "--host=i686-#{Ism.settings.systemTargetName}-linux-gnu",
                                "--prefix=/usr",
                                "--libdir=/usr/lib32",
                                "--enable-hashes=strong,glibc",
                                "--enable-obsolete-api=no",
                                "--disable-static",
                                "--disable-failure-tokens"],
                                path: buildDirectoryPath(entry: "32Bits"),
                                environment: {"CC" =>"gcc -m32"})
        end

        if option("x32Bits")
            configureSource([   "--host=#{Ism.settings.systemTarget}x32",
                                "--prefix=/usr",
                                "--libdir=/usr/libx32",
                                "--enable-hashes=strong,glibc",
                                "--enable-obsolete-api=no",
                                "--disable-static",
                                "--disable-failure-tokens"],
                                path: buildDirectoryPath(entry: "x32Bits"),
                                environment: {"CC" =>"gcc -mx32"})
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeSource(path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeSource(path: buildDirectoryPath(entry: "x32Bits"))
        end
    end
    
    def prepareInstallation
        super

        makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                    "install"],
                    path: buildDirectoryPath(entry: "MainBuild"))

        if option("32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "32Bits")}/32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            copyDirectory(  "#{buildDirectoryPath(entry: "32Bits")}/.libs",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32")

            makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                        "install-pkgconfigDATA"],
                        path: buildDirectoryPath(entry: "32Bits"))
        end

        if option("x32Bits")
            makeDirectory("#{buildDirectoryPath(entry: "x32Bits")}/x32Bits")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr")

            copyDirectory(  "#{buildDirectoryPath(entry: "x32Bits")}/.libs",
                            "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32")

            makeSource( ["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}",
                        "install-pkgconfigDATA"],
                        path: buildDirectoryPath(entry: "x32Bits"))
        end

        if option("32Bits")
            makeLink("libxcrypt.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib32/pkgconfig/libcrypt.pc",:symbolicLinkByOverwrite)
        end

        if option("x32Bits")
            makeLink("libxcrypt.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/libx32/pkgconfig/libcrypt.pc",:symbolicLinkByOverwrite)
        end
    end

end

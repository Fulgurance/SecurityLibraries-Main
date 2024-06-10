class Target < ISM::Software

   def build
        super

        makeSource(["BUILD_OPT=1",
                    "NSPR_INCLUDE_DIR=/usr/include/nspr",
                    "USE_SYSTEM_ZLIB=1",
                    "ZLIB_LIBS=-lz",
                    "NSS_ENABLE_WERROR=0",
                    "USE_64=#{architecture("x86_64") ? "1" : "0"}",
                    "NSS_USE_SYSTEM_SQLITE=#{option("Sqlite") ? "1" : "0"}",
                    "NSS_DISABLE_GTESTS=1"],
                    buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/pkgconfig")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss")

        runChmodCommand(["0755","/usr/include/nss"])

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin")

        Dir["#{workDirectoryPath}/dist/Linux*/lib/*.so"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)

            runChmodCommand(["0755",destination])
        end

        Dir["#{workDirectoryPath}/dist/Linux*/lib/*.chk"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)

            runChmodCommand(["0644",destination])
        end

        copyFile("#{workDirectoryPath}/dist/Linux*/lib/libcrmf.a","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/")

        runChmodCommand(["0644","/usr/lib/libcrmf.a"])

        Dir["#{workDirectoryPath}/dist/public/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)

            runChmodCommand(["0644",destination])
        end

        Dir["#{workDirectoryPath}/dist/private/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)

            runChmodCommand(["0644",destination])
        end

        copyFile("#{workDirectoryPath}/dist/Linux*/bin/{certutil,pk12util}","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile("#{buildDirectoryPath}/config/nss-config","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/nss-config")

        copyFile("#{buildDirectoryPath}/config/nss.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig/nss.pc")

        if option("P11-Kit")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libnssckbi.so")
            makeLink("./pkcs11/p11-kit-trust.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libnssckbi.so",:symbolicLinkByOverwrite)
        end
    end

    def install
        super

        runChmodCommand(["0755","/usr/bin/certutil"])
        runChmodCommand(["0755","/usr/bin/nss-config"])
        runChmodCommand(["0755","/usr/bin/pk12util"])
        runChmodCommand(["0644","/usr/lib/pkgconfig/nss.pc"])
    end

end

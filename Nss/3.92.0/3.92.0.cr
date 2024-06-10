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
        setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss",0o755)
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin")

        Dir["#{workDirectoryPath}/dist/Linux*/lib/*.so"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o755)
        end

        Dir["#{workDirectoryPath}/dist/Linux*/lib/*.chk"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        copyFile(Dir["#{workDirectoryPath}/dist/Linux*/lib/libcrmf.a"],"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/")
        setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libcrmf.a", 0o644)

        Dir["#{workDirectoryPath}/dist/public/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        Dir["#{workDirectoryPath}/dist/private/nss/*"].each do |filepath|
            filename = filepath.lchop(filepath[0..filepath.rindex("/")])
            destination = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/include/nss/#{filename}"

            copyFile(filepath,destination)
            setPermissions(destination,0o644)
        end

        copyFile(Dir["#{workDirectoryPath}/dist/Linux*/bin/{certutil,pk12util}"],"#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/")

        copyFile("#{buildDirectoryPath}/config/nss-config","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/nss-config")

        copyFile("#{buildDirectoryPath}/config/nss.pc","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/lib/pkgconfig/nss.pc")

        if option("P11-Kit")
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libnssckbi.so")
            makeLink("./pkcs11/p11-kit-trust.so","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/lib/libnssckbi.so",:symbolicLinkByOverwrite)
        end
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}usr/bin/certutil", 0o755)
        setPermissions("#{Ism.settings.rootPath}usr/bin/nss-config", 0o755)
        setPermissions("#{Ism.settings.rootPath}usr/bin/pk12util", 0o755)
        setPermissions("#{Ism.settings.rootPath}/usr/lib/pkgconfig/nss.pc", 0o644)
    end

end

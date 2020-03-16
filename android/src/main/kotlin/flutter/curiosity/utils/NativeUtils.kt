package flutter.curiosity.utilsimport android.Manifestimport android.content.Intentimport android.content.pm.PackageInfoimport android.content.res.Resourcesimport android.net.Uriimport android.os.Buildimport android.os.Processimport android.webkit.CookieManagerimport androidx.core.content.FileProviderimport flutter.curiosity.CuriosityPlugin.Companion.activityimport flutter.curiosity.CuriosityPlugin.Companion.callimport flutter.curiosity.CuriosityPlugin.Companion.contextimport java.io.Fileobject NativeUtils {    fun getBarHeight(barName: String?): Float {        val resources: Resources = context.resources        val resourceId = resources.getIdentifier(barName, "dimen", "android")        return resources.getDimensionPixelSize(resourceId).toFloat()    }    /**     * 安装apk     */    fun installApp(): String {        val apkPath = call.argument<String>("apkPath") ?: return Utils.resultError()        val file = File(apkPath)        val intent = Intent(Intent.ACTION_VIEW)        //版本在7.0以上是不能直接通过uri访问的        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { //参数1 上下文, 参数2 Provider主机地址 和配置文件中保持一致   参数3  共享的文件            val apkUri = FileProvider.getUriForFile(context, context.packageName + ".provider", file)            //添加这一句表示对目标应用临时授权该Uri所代表的文件            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")        } else {            intent.setDataAndType(Uri.fromFile(file),                    "application/vnd.android.package-archive")        }        activity.startActivity(intent)        return Utils.resultSuccess()    }    /**     * 获取路径文件和文件夹大小     */    fun getFilePathSize(): String? {        val filePath = call.argument<String>("filePath") ?: return null        return if (FileUtils.isDirectoryExist(filePath)) {            val file = File(filePath)            if (file.isDirectory) {                FileUtils.getDirectorySize(file)            } else {                FileUtils.getFileSize(file)            }        } else {            "NotFile"        }    }    /**     * 退出app     */    fun exitApp() {        //杀死进程，否则就算退出App，App处于空进程并未销毁，再次打开也不会初始化Application        //从而也不会执行getJSBundleFile去更换bundle的加载路径 !!!        Process.killProcess(Process.myPid())        System.exit(0)    }    /**     * 获取cookie     */    fun getAllCookie(): String {        val url = call.argument<String>("url") ?: return Utils.resultError()        return CookieManager.getInstance().getCookie(url)    }    /**     * 清除cookie     */    fun clearAllCookie() {        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {            CookieManager.getInstance().removeAllCookies {}        }    }    /**     * 判断手机是否安装某个应用     *     * @return true：安装，false：未安装 error 参数参数     */    fun isInstallApp(): Any {        val packageName = call.argument<String>("packageName") ?: Utils.resultError()        val packages: MutableList<PackageInfo> = context.packageManager.getInstalledPackages(0) // 获取所有已安装程序的包信息        for (packageInfo in packages) {            return packageName == packageInfo.packageName        }        return false    }    /**     * 跳转至应用商店     */    fun goToMarket(): String {        val packageName = call.argument<String>("packageName") ?: return Utils.resultError()        val marketPackageName = call.argument<String>("marketPackageName") ?: return Utils.resultError()        val uri = Uri.parse("market://details?id=$packageName")        val intent = Intent(Intent.ACTION_VIEW, uri)        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)        if (marketPackageName != "") { // 如果没给市场的包名，则系统会弹出市场的列表让你进行选择。            intent.setPackage(marketPackageName)        }        context.startActivity(intent)        return Utils.resultSuccess()    }    /**     * 拨打电话     */    fun callPhone(): String {        if (!Utils.checkPermission(Manifest.permission.CALL_PHONE)) return Utils.resultError("Lack of CALL_PHONE permissions")        val phoneNumber = call.argument<String>("phoneNumber")        val directDial = call.argument<Boolean>("directDial")        val intent = Intent()        if (directDial!!) {            intent.action = Intent.ACTION_CALL        } else {            intent.action = Intent.ACTION_DIAL        }        intent.data = Uri.parse("tel:$phoneNumber");        activity.startActivity(intent)        return Utils.resultSuccess()    }    /**     * 打开url     */    fun openUrl(): String {        val url = call.argument<String>("url") ?: return Utils.resultError()        val browserName = call.argument<String>("browserPackageName")        val className = call.argument<String>("browserClassName")        val uri = Uri.parse(url)        val intent = Intent(Intent.ACTION_VIEW, uri)        if (browserName != null && className != null) {            intent.setClassName(browserName, className) //打开QQ浏览器        }        activity.startActivity(intent)        return Utils.resultSuccess()    }}
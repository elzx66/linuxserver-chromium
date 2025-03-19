
# 使用 linuxserver/chromium 作为基础镜像
FROM linuxserver/chromium:latest

# 设置环境变量，指定语言为中文
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 更新系统并安装中文语言包和字体
RUN apt-get update && apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

# 配置 Chrome 接受中文语言
RUN echo '{ "intl": { "accept_languages": "zh-CN,zh" } }' > /config/chromium/Default/Preferences

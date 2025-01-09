FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 6.2 7.0 7.2 7.5 8.0 8.6"

# Umgebungsvariablen setzen
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

# System-Updates und Abhängigkeiten installieren
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    git \
    wget \
    libffi-dev \
    libssl-dev \
    libbz2-dev \
    liblzma-dev \
    libreadline-dev \
    libsqlite3-dev \
    zlib1g-dev \
    xz-utils \
    tk-dev \
    libopenblas-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install \
    absl-py==1.4.0  \
    addict==2.4.0 \
    aiohttp==3.8.4 \
    aiosignal==1.3.1 \
    albumentations==1.2.1 \
    antlr4-python3-runtime==4.8 \ 
    anyio==3.6.2 \
    appdirs==1.4.4 \
    asttokens==2.2.1 \
    async-timeout==4.0.2 \
    attrs \
    backcall==0.2.0 \
    black==21.4b2 \
    cachetools==5.3.0 \
    click \
    cloudpickle==2.1.0 \
    comm==0.1.3 \
    configargparse==1.5.3 \
    contourpy \
    cycler==0.11.0 \
    dash==2.9.3 \
    dash-core-components==2.0.0 \
    dash-html-components==2.0.0 \
    dash-table==5.0.0 \
    debugpy==1.6.7 \
    decorator==5.1.1 \
    docker-pycreds==0.4.0 \
    executing==1.2.0 \
    fastapi==0.95.1 \
    fastjsonschema==2.16.3 \
    fire==0.4.0 \
    flake8 \
    flask \
    fonttools \
    frozenlist==1.3.3 \
    fsspec \
    fvcore==0.1.5.post20220512 \
    gitdb==4.0.10 \
    gitpython==3.1.31 \
    google-auth==2.17.3 \
    google-auth-oauthlib==1.0.0 \
    grpcio==1.54.0 \
    h11==0.14.0 \
    hydra-core==1.0.5 \
    imageio==2.21.1 \
    importlib-metadata \
    iopath==0.1.10 \
    ipykernel \
    ipython \
    ipywidgets==8.0.6 \
    itsdangerous==2.1.2 \
    jedi==0.18.2 \
    jinja2==3.1.2 \
    joblib==1.2.0 \
    jsonschema \
    jupyter-client \
    jupyter-core \
    jupyterlab-widgets \
    kiwisolver==1.4.4 \
    lazy-loader==0.2 \
    loguru==0.6.0 \
    markdown \
    markupsafe==2.1.2 \
    matplotlib \
    matplotlib-inline \
    multidict==6.0.4 \
    mypy-extensions==1.0.0 \
    natsort==8.3.1 \
    nbformat==5.7.0 \
    nest-asyncio==1.5.6 \
    networkx \
    ninja==1.10.2.3 \
    numpy \
    oauthlib==3.2.2 \
    omegaconf==2.0.6 \
    open3d==0.17.0 \
    opencv-python-headless==4.7.0.72 \ 
    pandas \
    parso==0.8.3 \
    pathspec==0.11.1 \
    pathtools==0.1.2 \
    pexpect==4.8.0 \
    pickleshare==0.7.5 \
    pillow==9.5.0 \
    pip==23.1 \
    platformdirs==3.2.0 \
    plotly==5.14.1 \
    plyfile==0.7.4 \
    portalocker==2.7.0 \
    prompt-toolkit==3.0.38 \
    protobuf==4.22.3 \
    psutil==5.9.5 \
    ptyprocess==0.7.0 \
    pure-eval==0.2.2 \
    pyasn1==0.5.0 \
    pyasn1-modules==0.3.0 \
    pycocotools \
    pydantic==1.10.7 \
    pydeprecate==0.3.2 \
    pygments==2.15.1 \
    pyparsing==3.0.9 \
    pyquaternion==0.9.9 \
    pyrsistent==0.19.3 \
    python-dateutil==2.8.2 \
    python-dotenv==0.20.0 \
    python-multipart==0.0.6 \
    pytz==2023.3 \
    pyviz3d==0.2.28 \
    pywavelets \
    pyyaml==5.4.1 \
    pyzmq==25.0.2 \
    qudida==0.0.4 \
    regex \
    requests-oauthlib==1.3.1 \
    rsa==4.9 \
    scikit-image \
    scikit-learn \
    scipy \
    sentry-sdk==1.20.0 \
    setproctitle==1.3.2 \
    smmap==5.0.0 \
    sniffio==1.3.0 \
    stack-data==0.6.2 \
    starlette==0.26.1 \
    tabulate==0.9.0 \
    tenacity==8.2.2 \
    tensorboard \
    tensorboard-data-server \
    tensorboard-plugin-wit \
    termcolor==2.2.0 \
    threadpoolctl==3.1.0 \
    tifffile \
    toml==0.10.2 \
    tornado \
    traitlets==5.9.0 \
    trimesh==3.14.0 \
    typing-extensions==4.5.0 \
    tzdata==2023.3 \
    uvicorn==0.21.1 \
    volumentations==0.1.8 \
    wandb==0.15.0 \
    wcwidth==0.2.6 \
    werkzeug==2.2.3 \
    widgetsnbextension==4.0.7 \
    yacs==0.1.8 \
    yarl==1.8.2 \
    zipp==3.15.0 

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub \
    && apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6
RUN pip install torchvision==0.13.1
RUN pip install spconv-cu113==2.1.25
RUN pip install torch-scatter -f https://data.pyg.org/whl/torch-1.12.1+cu113.html

RUN pip install 'git+https://github.com/facebookresearch/detectron2.git@710e7795d0eeadf9def0e7ef957eea13532e34cf' --no-deps

# BEGIN cmake version 3.18
# required for apriltag
# RUN wget https://cmake.org/files/v3.18/cmake-3.18.0-Linux-x86_64.sh -O /tmp/cmake-install.sh
# RUN chmod u+x /tmp/cmake-install.sh
# RUN mkdir /opt/cmake-3.18.0
# RUN echo "y" | /tmp/cmake-install.sh --prefix=/opt/cmake-3.18.0
# RUN rm /tmp/cmake-install.sh
# RUN ln -s /opt/cmake-3.18.0/cmake-3.18.0-Linux-x86_64/bin/* /usr/local/bin
# END cmake version 3.18

#RUN apt-get install libsparsehash-dev 

# # BEGIN Install Segmentator 
# WORKDIR /root
# RUN git clone https://github.com/Karbo123/segmentator.git
# WORKDIR /root/segmentator/csrc
# RUN mkdir build
# WORKDIR /root/segmentator/csrc/build
# RUN cmake .. \
#     -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` \
#     -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
#     -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
#     -DCMAKE_INSTALL_PREFIX=`python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())'` 
# RUN make && make install
# # END Install Segmentator

# BEGIN Install Segmentator 
# WORKDIR /root
# RUN git clone https://github.com/Karbo123/segmentator.git \
#     && cd segmentator/csrc \
#     && mkdir build && cd build \
#     && cmake .. \
#         -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` \
#         -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
#         -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
#         -DCMAKE_INSTALL_PREFIX=`python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())'` \
#     && make && make install
# END Install Segmentator

WORKDIR /root

# # Install OpenMMLab projects
# RUN pip install --no-deps \
#     mmengine==0.7.3 \
#     mmdet==3.0.0 \
#     mmsegmentation==1.0.0 \
#     git+https://github.com/open-mmlab/mmdetection3d.git@22aaa47fdb53ce1870ff92cb7e3f96ae38d17f61
# RUN pip install mmcv==2.0.0 -f https://download.openmmlab.com/mmcv/dist/cu116/torch1.13.0/index.html --no-deps

# # Install MinkowskiEngine
# # Feel free to skip nvidia-cuda-dev if minkowski installation is fine
# RUN apt-get update \
#     && apt-get -y install libopenblas-dev nvidia-cuda-dev
# RUN TORCH_CUDA_ARCH_LIST="6.1 7.0 8.6" \
#     pip install git+https://github.com/NVIDIA/MinkowskiEngine.git@02fc608bea4c0549b0a7b00ca1bf15dee4a0b228 -v --no-deps \
#     --install-option="--blas=openblas" \
#     --install-option="--force_cuda"

# # Install torch-scatter 
# RUN pip install torch-scatter==2.1.2 -f https://data.pyg.org/whl/torch-1.13.0+cu116.html --no-deps

# # Install ScanNet superpoint segmentator
# RUN git clone https://github.com/Karbo123/segmentator.git \
#     && cd segmentator/csrc \
#     && git reset --hard 76efe46d03dd27afa78df972b17d07f2c6cfb696 \
#     && mkdir build \
#     && cd build \
#     && cmake .. \
#         -DCMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` \
#         -DPYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
#         -DPYTHON_LIBRARY=$(python -c "import distutils.sysconfig as sysconfig; print(sysconfig.get_config_var('LIBDIR'))") \
#         -DCMAKE_INSTALL_PREFIX=`python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())'` \
#     && make \
#     && make install \
#     && cd ../../..

# # Install remaining python packages
# RUN pip install --no-deps \
#     spconv-cu116==2.3.6 \
#     addict==2.4.0 \
#     yapf==0.33.0 \
#     termcolor==2.3.0 \
#     packaging==23.1 \
#     numpy==1.24.1 \
#     rich==13.3.5 \
#     opencv-python==4.7.0.72 \
#     pycocotools==2.0.6 \
#     Shapely==1.8.5 \
#     scipy==1.10.1 \
#     terminaltables==3.1.10 \
#     numba==0.57.0 \
#     llvmlite==0.40.0 \
#     pccm==0.4.7 \
#     ccimport==0.4.2 \
#     pybind11==2.10.4 \
#     ninja==1.11.1 \
#     lark==1.1.5 \
#     cumm-cu116==0.4.9 \
#     pyquaternion==0.9.9 \
#     lyft-dataset-sdk==0.0.8 \
#     pandas==2.0.1 \
#     python-dateutil==2.8.2 \
#     matplotlib==3.5.2 \
#     pyparsing==3.0.9 \
#     cycler==0.11.0 \
#     kiwisolver==1.4.4 \
#     scikit-learn==1.2.2 \
#     joblib==1.2.0 \
#     threadpoolctl==3.1.0 \
#     cachetools==5.3.0 \
#     nuscenes-devkit==1.1.10 \
#     trimesh==3.21.6 \
#     open3d==0.17.0 \
#     plotly==5.18.0 \
#     dash==2.14.2 \
#     plyfile==1.0.2 \
#     flask==3.0.0 \
#     werkzeug==3.0.1 \
#     click==8.1.7 \
#     blinker==1.7.0 \
#     itsdangerous==2.1.2 \
#     importlib_metadata==2.1.2 \
#     zipp==3.17.0

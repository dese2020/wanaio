FROM wlsdml1114/engui_genai-base_blackwell:1.1 AS runtime


RUN pip install -U "huggingface_hub[hf_transfer]"
RUN pip install runpod websocket-client

WORKDIR /


# Antes de clonar, ajusta git
RUN git config --global http.version HTTP/1.1 \
 && git config --global http.lowSpeedLimit 1 \
 && git config --global http.lowSpeedTime 600 \
 && git config --global http.postBuffer 524288000


RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd /ComfyUI && \
    pip install --no-cache-dir -r requirements.txt

#RUN cd /ComfyUI/custom_nodes && \
#    git clone https://github.com/Comfy-Org/ComfyUI-Manager.git && \
#    cd ComfyUI-Manager && \
#    pip install --no-cache-dir -r requirements.txt

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    cd ComfyUI-KJNodes && \
    pip install --no-cache-dir -r requirements.txt

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git && \
    cd ComfyUI-Frame-Interpolation && \
    python install.py
    
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    cd ComfyUI-VideoHelperSuite && \
    pip install --no-cache-dir -r requirements.txt
	
#RUN cd /ComfyUI/custom_nodes && \
#    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
#    cd ComfyUI-WanVideoWrapper && \
#    pip install --no-cache-dir -r requirements.txt
	
#RUN cd /ComfyUI/custom_nodes && \
#    git clone https://github.com/GiusTex/ComfyUI-Wan-TimeToMove.git
#

#RUN cd /ComfyUI/custom_nodes && \
#    git clone https://github.com/kijai/ComfyUI-GIMM-VFI.git && \
#    cd ComfyUI-GIMM-VFI && \
#    pip install --no-cache-dir -r requirements.txt
	
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && \
    pip install --no-cache-dir -r requirements.txt

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/city96/ComfyUI-GGUF.git && \
    cd ComfyUI-GGUF && \
    pip install --no-cache-dir -r requirements.txt
	
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/wallen0322/ComfyUI-Wan22FMLF.git
	
	
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    cd ComfyUI_essentials && \
    pip install --no-cache-dir -r requirements.txt
	
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/M1kep/ComfyLiterals.git
	


ENV PATH="/opt/venv/bin:${PATH}"
WORKDIR /

# Copiar modelos de las TRES etapas de assets
RUN wget -q https://huggingface.co/BigDannyPt/Wan-2.2-Remix-GGUF/resolve/main/I2V/v3.0/High/wan22RemixT2VI2V_i2vHighV30-Q8_0.gguf -O /ComfyUI/models/diffusion_models/wan22RemixT2VI2V_i2vHighV30-Q8_0.gguf && \
	wget -q https://huggingface.co/BigDannyPt/Wan-2.2-Remix-GGUF/resolve/main/I2V/v3.0/Low/wan22RemixT2VI2V_i2vLowV30-Q8_0.gguf -O /ComfyUI/models/diffusion_models/wan22RemixT2VI2V_i2vLowV30-Q8_0.gguf && \
	wget -q https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors -O /ComfyUI/models/vae/wan_2.1_vae.safetensors && \
	wget -q https://huggingface.co/city96/umt5-xxl-encoder-gguf/resolve/main/umt5-xxl-encoder-Q8_0.gguf -O /ComfyUI/models/text_encoders/umt5-xxl-encoder-Q8_0.gguf

RUN wget -q https://huggingface.co/datasets/hijdese2020/wan22_datalora/resolve/main/allnsfw/wan22-k3nk4llinon3-15epoc-full-low-k3nk.safetensors -O /ComfyUI/models/loras/wan22-k3nk4llinon3-15epoc-full-low-k3nk.safetensors
RUN wget -q https://huggingface.co/datasets/hijdese2020/wan22_datalora/resolve/main/allnsfw/wan22-k3nk4llinon3-16epoc-full-high-k3nk.safetensors -O /ComfyUI/models/loras/wan22-k3nk4llinon3-16epoc-full-high-k3nk.safetensors


COPY . .
RUN mkdir -p /ComfyUI/user/default/ComfyUI-Manager
COPY config.ini /ComfyUI/user/default/ComfyUI-Manager/config.ini
COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml
#COPY rife49.pth /ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation/ckpts/rife/rife49.pth
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

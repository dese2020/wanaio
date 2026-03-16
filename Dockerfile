
# syntax=docker/dockerfile:1.7

# 1) Etapas de assets (alias distintos)
#FROM dese251/sviwan22:bassets AS assets_b
#FROM dese251/sviwan22:hassets AS assets_h
#FROM dese251/sviwan22:lassets AS assets_l
#FROM dese251/sviwan22:lora AS lora
#FROM dese251/sviwan22:lora2 AS lora2

# 2) Imagen final basada en runtime (una sola FROM final)
FROM dese251/sviwan22:run AS final
ENV PATH="/opt/venv/bin:${PATH}"
WORKDIR /

# Copiar modelos de las TRES etapas de assets
RUN wget -q https://huggingface.co/BigDannyPt/Wan-2.2-Remix-GGUF/resolve/main/I2V/v2.1/High/wan22RemixT2VI2V_i2vHighV21-Q8_0.gguf -O /ComfyUI/models/diffusion_models/wan22RemixT2VI2V_i2vHighV21-Q8_0.gguf && \
	wget -q https://huggingface.co/BigDannyPt/Wan-2.2-Remix-GGUF/resolve/main/I2V/v2.1/Low/wan22RemixT2VI2V_i2vLowV21-Q8_0.gguf -O /ComfyUI/models/diffusion_models/wan22RemixT2VI2V_i2vLowV21-Q8_0.gguf && \
	wget -q https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors -O /ComfyUI/models/vae/wan_2.1_vae.safetensors && \
	wget -q https://huggingface.co/city96/umt5-xxl-encoder-gguf/resolve/main/umt5-xxl-encoder-Q8_0.gguf -O /ComfyUI/models/text_encoders/umt5-xxl-encoder-Q8_0.gguf

RUN wget -q https://huggingface.co/datasets/hijdese2020/wan22_datalora/resolve/main/allnsfw/wan22-k3nk4llinon3-15epoc-full-low-k3nk.safetensors -O /ComfyUI/models/loras/wan22-k3nk4llinon3-15epoc-full-low-k3nk.safetensors
RUN wget -q https://huggingface.co/datasets/hijdese2020/wan22_datalora/resolve/main/allnsfw/wan22-k3nk4llinon3-16epoc-full-high-k3nk.safetensors -O /ComfyUI/models/loras/wan22-k3nk4llinon3-16epoc-full-high-k3nk.safetensors
RUN wget -q https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_HIGH_lora_rank_128_fp16.safetensors -O /ComfyUI/models/loras/SVI_v2_PRO_Wan2.2-I2V-A14B_HIGH_lora_rank_128_fp16.safetensors 
RUN wget -q https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Stable-Video-Infinity/v2.0/SVI_v2_PRO_Wan2.2-I2V-A14B_LOW_lora_rank_128_fp16.safetensors -O /ComfyUI/models/loras/SVI_v2_PRO_Wan2.2-I2V-A14B_LOW_lora_rank_128_fp16.safetensors 
	

# Si hay colisiones de nombres, el último COPY gana.
#COPY --from=assets_b /ComfyUI/models/ /ComfyUI/models/
#COPY --from=assets_h /ComfyUI/models/ /ComfyUI/models/
#COPY --from=assets_l /ComfyUI/models/ /ComfyUI/models/
#COPY --from=lora /ComfyUI/models/loras/ /ComfyUI/models/loras/
#COPY --from=lora2 /ComfyUI/models/loras/ /ComfyUI/models/loras/

# Archivos estables ya están en runtime (config.ini, extra_model_paths.yaml, entrypoint.sh)

# ---- Cambios frecuentes: SOLO aquí ----

# (Opcional) Verifica permisos del entrypoint si no estuvieran en la base:
# RUN chmod +x /entrypoint.sh
COPY . .
RUN rm -rf /ComfyUI/custom_nodes/ComfyUI-Manager/
COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml
#COPY rife49.pth /ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation/ckpts/rife/rife49.pth
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

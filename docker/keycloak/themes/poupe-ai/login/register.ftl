<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <h1 id="kc-page-title"><span style="color: #ccc;">Poupe.</span>AI</h1>
    <#elseif section = "form">
        <p style="text-align: center; color: #ccc; margin-bottom: 25px;">
            Vamos dar o primeiro passo rumo ao controle financeiro.
        </p>

        <form id="kc-register-form" action="${url.registrationAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <input type="text" id="email" class="${properties.kcInputClass!}" name="email" value="${(register.formData.email!'')}" placeholder="Digite seu email" autocomplete="email" />
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <input type="password" id="password" class="${properties.kcInputClass!}" name="password" placeholder="Crie sua senha" autocomplete="new-password"/>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <input type="password" id="password-confirm" class="${properties.kcInputClass!}" name="password-confirm" placeholder="Confirme sua senha" autocomplete="new-password"/>
            </div>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="Criar Conta"/>
                </div>
            </div>
        </form>
        <div id="kc-registration" style="text-align: center; margin-top: 100px;">
            <span>Já tem uma conta? <a href="${url.loginUrl}">Clique Aqui</a></span>
       </div>
    <#elseif section = "info">
    </#if>
</@layout.registrationLayout>
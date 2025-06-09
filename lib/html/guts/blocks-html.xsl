<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:import href="../../queries/queries.xsl"/>


    <xsl:template match="*[contains(@class, ' xatool/demixed ') and not(parent::p)]"
        mode="dtea:outElementName">
        <xsl:value-of select="'p'"/>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, 'xatool/demixed ') and parent::p]">

        <div class="block dita__topic p">
            <xsl:apply-templates/>
        </div>

    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, ' ut-d/imagemap ')]" mode="dtea:outElementName">
        <xsl:value-of select="'map'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/lq ')]" mode="dtea:outElementName">
        <xsl:value-of select="'blockquote'"/>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="dtea:outElementName">
        <xsl:value-of select="'p'"/>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="dtea:outElementName">
        <xsl:value-of select="'pre'"/>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/related-links ')]" mode="dtea:outElementName">
        <xsl:value-of select="'nav'"/>
    </xsl:template>
    
  
    <xsl:template match="*[contains(@class, ' topic/sl ')]" mode="dtea:outElementName">
        <xsl:value-of select="'dl'"/>
    </xsl:template>
    
   
    <xsl:template match="*[contains(@class, ' topic/sli ')]" mode="dtea:outElementName">
        <xsl:value-of select="'dt'"/>
    </xsl:template>
    
</xsl:stylesheet>
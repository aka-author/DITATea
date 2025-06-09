<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dtea="http://itsurim.com/dtea" xmlns:xat="http://itsurim.com/xatool"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="dtea xat xs" version="2.0">

    <xsl:import href="../../../xatool/common/xsl-2.0/common.xsl"/>
    <xsl:import href="../../../xatool/utils/xsl-2.0/pathuri.xsl"/>
    

    <xsl:template match="*" mode="dtea:html.imgURI">
        <xsl:value-of select="@href"/>
    </xsl:template>
    
    <xsl:function name="dtea:html.imgURI">
        
        <xsl:param name="image"/>
        
        <xsl:apply-templates select="$image" mode="dtea:html.imgURI"/>
        
    </xsl:function>
    

    <xsl:function name="dtea:html.imgSize">
        <xsl:param name="srcSize"/>
        <xsl:choose>
            <xsl:when test="ends-with($srcSize, 'cm')">
                <xsl:value-of select="number(substring-before($srcSize, 'cm')) * 72 * 0.393701"/>
            </xsl:when>
            <xsl:when test="ends-with($srcSize, 'mm')">
                <xsl:value-of select="number(substring-before($srcSize, 'mm')) * 72 * 0.0393701"/>
            </xsl:when>
            <xsl:when test="ends-with($srcSize, 'in')">
                <xsl:value-of select="number(substring-before($srcSize, 'in')) * 72"/>
            </xsl:when>
            <xsl:when test="ends-with($srcSize, 'pt')">
                <xsl:value-of select="number(substring-before($srcSize, 'pt')) * 72 * 0.0138889"/>
            </xsl:when>
            <xsl:when test="ends-with($srcSize, 'px')">
                <xsl:value-of select="number(substring-before($srcSize, 'px'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$srcSize"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xsl:template match="*[contains(@class, ' topic/image ')]" mode="dtea:outElementName">
        <xsl:value-of select="'img'"/>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, ' topic/image ')]" mode="dtea:cssClassNamesSpecific">
        <xsl:value-of select="xat:uri.type(dtea:html.imgURI(@href))"/>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class, ' topic/image ')]" mode="dtea:specificAttrs">
        
        <xsl:attribute name="src" select="dtea:html.imgURI(.)"/>
        
        <xsl:copy-of select="xat:usefulAttr('width', dtea:html.imgSize(@width))"/>
        <xsl:copy-of select="xat:usefulAttr('height', dtea:html.imgSize(@height))"/>
        
        <xsl:attribute name="alt" select="*[contains(@class, ' topic/alt ')]"/>
        
    </xsl:template>
    
</xsl:stylesheet>

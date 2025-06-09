<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dtea="http://itsurim.com/dtea"
    xmlns:xat="http://itsurim.com/xatool" exclude-result-prefixes="dtea xat xs" version="2.0">


    <xsl:template match="*" mode="dtea:outId">
        <xsl:value-of select="@id"/>
    </xsl:template>

    <xsl:function name="dtea:outId">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:outId"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:ordNumber" as="xs:integer">
        <xsl:variable name="class" select="@class"/>
        <xsl:value-of select="count(preceding-sibling::*[@class = $class]) + 1"/>
    </xsl:template>

    <xsl:function name="dtea:ordNumber" as="xs:integer">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:ordNumber"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:width"/>

    <xsl:function name="dtea:width">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:width"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:height"/>

    <xsl:function name="dtea:height">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:height"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:textAlign"/>

    <xsl:function name="dtea:textAlign">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:textAlign"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:verticalAlign"/>

    <xsl:function name="dtea:verticalAlign">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:verticalAlign"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:level" as="xs:integer">
        <xsl:value-of select="0"/>
    </xsl:template>

    <xsl:function name="dtea:level" as="xs:integer">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:level"/>
    </xsl:function>


    <xsl:template match="*" mode="dtea:hasContent" as="xs:boolean">
        <xsl:value-of select="exists(text() | *)"/>
    </xsl:template>

    <xsl:function name="dtea:hasContent" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:hasContent"/>
    </xsl:function>
    
    
    <xsl:template match="*" mode="dtea:isBroken" as="xs:boolean">
        <xsl:sequence select="false()"/>
    </xsl:template>
    
    <xsl:function name="dtea:isBroken" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:isBroken"/>
    </xsl:function>
    
    
    <xsl:template match="*" mode="dtea:type">
        <xsl:sequence select="'generic'"/>
    </xsl:template>
    
    <xsl:function name="dtea:type">    
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:type"/>
    </xsl:function>
    
    
    <xsl:template match="*" mode="dtea:captionPlainText">
        <xsl:sequence select="''"/>
    </xsl:template>
    
    <xsl:function name="dtea:captionPlainText">    
        <xsl:param name="element"/>
        <xsl:apply-templates select="$element" mode="dtea:captionPlainText"/>
    </xsl:function>
    

</xsl:stylesheet>
